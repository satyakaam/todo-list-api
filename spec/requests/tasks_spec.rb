require 'rails_helper'

describe 'GET api/v1/tasks' do
  context '#index' do
    it 'returns Tasks' do
      create_list(:task, 5)

      get api_v1_tasks_path

      expect(response.status).to eq 200
      expect(response.body).to have_json_size(5).at_path('data')
      expect(response.body).to match_response_schema('tasks')
    end

    it 'returns Tasks with tags' do
      create_list(:task, 5, :with_tags)

      get api_v1_tasks_path

      expect(response.status).to eq 200
      expect(response.body).to have_json_size(5).at_path('data')
      expect(response.body).to have_json_size(15).at_path('included')
      expect(response.body).to match_response_schema('tasks_with_tags')
    end
  end
end

describe 'GET api/v1/tasks/:id' do
  context '#show' do
    it 'returns a Task' do
      task = create(:task)

      get api_v1_task_path(task)

      expect(response.status).to eq 200
      expect(response.body).to match_response_schema('task')
    end

    it 'returns a Task with tags' do
      task = create(:task, :with_tags)

      get api_v1_task_path(task)

      expect(response.status).to eq 200
      expect(response.body).to have_json_size(3).at_path('included')
      expect(response.body).to match_response_schema('task_with_tags')
    end
  end
end

describe 'POST api/v1/tasks' do
  context '#create' do
    it 'creates a new task with valid params' do
      post(
        api_v1_tasks_path,
        params: valid_task_params,
      )

      expect(Task.count).to eq 1
      expect(response.status).to eq 201
      expect(response.body).to have_json_size(2).at_path('included')
      expect(response.body).to match_response_schema('task_with_tags')
    end

    it 'does not create a new task with invalid params' do
      post(
        api_v1_tasks_path,
        params: invalid_task_params(title: 'Laundry'),
      )

      expect(response.status).to eq 422
      expect(response.body).to match_response_schema('error')
    end
  end
end

describe 'DELETE api/v1/tasks/:id' do
  context '#destroy' do
    it 'deletes the task' do
      task = create(:task)
      delete api_v1_task_path(task)

      expect(response.status).to eq 200
      expect(response.body).to match('Successfully deleted')
    end
  end
end

describe 'PUT api/v1/tasks/:id' do
  context '#update' do
    it 'updates a task with valid params' do
      task = create(:task)

      put(
        api_v1_task_path(task),
        params: valid_task_params(id: task.id, title: 'Updated Tag', tags: ['Updated tag']),
      )

      expect(response.status).to eq 200
      expect(response.body).to have_json_size(1).at_path('included')
      expect(response.body).to match_response_schema('task_with_tags')
    end

    it 'does not update a task with invalid params' do
      task = create(:task)

      put(
        api_v1_task_path(task),
        params: invalid_task_params(id: task.id),
      )

      expect(response.status).to eq 422
      expect(response.body).to match_response_schema('error')
    end
  end
end

def valid_task_params(id: nil, title: 'Laundry', tags: ['urgent', 'boring'])
  {
    'data': {
      'id': "#{id}",
      'type': 'tasks',
      'attributes': {
        'title': "#{title}",
        'tags': tags,
      },
    },
  }
end

def invalid_task_params(id: nil, title: nil, tags: [1,2])
  {
    'data': {
      'id': id,
      'type': 'tasks',
      'attributes': {
        'title': title,
        'tags': "#{tags}",
      },
    },
  }
end