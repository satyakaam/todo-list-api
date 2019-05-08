module Errors
  class TypeMismatch < Errors::StandardError
    def initialize(title:)
      super(
        title: title || "Something went wrong",
        status: :unprocessable_entity,
        detail: "We can only process the entry.",
        source: { pointer: "/request/url/:id" }
      )
    end
  end
end
