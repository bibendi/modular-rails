# frozen_string_literal: true

FactoryBot.define do
  factory :blob, class: "ActiveStorage::Blob" do
    transient do
      file { Rack::Test::UploadedFile.new(File.join(__dir__, "../fixtures/files/blob.jpg"), "image/jpeg") }
    end

    io { file }
    filename { "blob.jpg" }
    content_type { file.content_type }
    identify { false }

    initialize_with do
      attrs = attributes.slice(:filename, :content_type)
      ActiveStorage::Blob.new(**attrs).tap do |blob|
        blob.upload(attributes[:io], identify: attributes[:identify])
      end
    end

    to_create { |instance| instance.save! }
  end
end
