json.extract! article, :id, :title, :description, :status, :author, :website, :meta_title, :meta_description, :created_at, :updated_at
json.url article_url(article, format: :json)
