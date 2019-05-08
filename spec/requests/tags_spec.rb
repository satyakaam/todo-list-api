require 'rails_helper'

describe 'GET api/v1/tags' do
  context '#index' do
    it 'returns Tags' do
      create_list(:tag, 5)

      get api_v1_tags_path

      expect(response.body).to have_json_size(5).at_path('data')
      expect(response.status).to eq 200
      expect(response.body).to match_response_schema('tags')
    end

    it 'returns Tags with tasks' do
      tags = create_list(:tag, 5)
      create_list(:task, 5, tags: tags)

      get api_v1_tags_path
      json = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.body).to have_json_size(5).at_path('data')
      expect(response.body).to have_json_size(5).at_path('included')
      expect(response.body).to match_response_schema('tags_with_tasks')
    end
  end
end

describe 'GET api/v1/tags/:id' do
  context '#show' do
    it 'returns a Tag' do
      tag = create(:tag)

      get api_v1_tag_path(tag)
      json = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.body).to match_response_schema('tag')
    end

    it 'returns a Tag with tasks' do
      tag = create(:tag)
      create_list(:task, 5, tags: [tag])

      get api_v1_tag_path(tag)

      expect(response.status).to eq 200
      expect(response.body).to match_response_schema('tag_with_tasks')
    end
  end
end

describe 'POST api/v1/tags' do
  context '#create' do
    it 'creates a new tag with valid params' do
      post(
        api_v1_tags_path,
        params: valid_tag_params,
      )

      expect(Tag.count).to eq 1
      expect(response.status).to eq 201
      expect(response.body).to match_response_schema('tag')
    end

    it 'does not create a new tag with invalid params' do
      post(
        api_v1_tags_path,
        params: invalid_tag_params,
      )

      expect(response.status).to eq 422
      expect(response.body).to match_response_schema('errors')
    end
  end
end

describe 'DELETE api/v1/tags/:id' do
  context '#destroy' do
    it 'deletes the tag' do
      tag = create(:tag)
      delete api_v1_tag_path(tag)

      expect(response.status).to eq 200
      expect(response.body).to match('Successfully deleted')
    end
  end
end

describe 'PUT api/v1/tags/:id' do
  context '#update' do
    it 'updates a tag with valid params' do
      tag = create(:tag)

      put(
        api_v1_tag_path(tag),
        params: valid_tag_params(id: tag.id, title: 'Updated Tag'),
      )

      expect(response.status).to eq 200
      expect(response.body).to match_response_schema('tag')
    end

    it 'does not update a tag with invalid params' do
      tag = create(:tag)

      put(
        api_v1_tag_path(tag),
        params: invalid_tag_params(id: tag.id),
      )
      json = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(response.body).to match_response_schema('errors')
    end
  end
end

def valid_tag_params(id: nil, title: 'Urgent')
  {
    data: {
      id: id,
      type: 'tags',
      attributes: {
        title: title,
      },
    },
  }
end

def invalid_tag_params(id: nil)
  {
    data: {
      id: id,
      type: 'tags',
      attributes: {
        title: nil,
      },
    },
  }
end