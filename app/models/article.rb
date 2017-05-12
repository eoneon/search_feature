class Article < ActiveRecord::Base
  enum status: [ :draft, :pending_review, :flagged, :published]

  #note: the WHERE clause is passed in as an argument
  #thus we only need the name of the method (key) and not the value for the second method below
  scope :with_author, -> {(where("'author' IS NOT NULL ")) }
  scope :with_website, -> {(where("'website' IS NOT NULL ")) }
  scope :with_meta_title, -> {(where("'meta_title' IS NOT NULL ")) }
  scope :with_meta_description, -> {(where("'meta_description' IS NOT NULL ")) }

  #figure out: methods = params[:article][:methods]
  def self.send_chain(methods)
    #methods:
    #inject: interates over methods object, and for each item (self) it calls send, which evaluates a string (name_of_scope) as a method.
    #the result is that it chains the collection of scopes which are passe as strings
    methods.inject(self, :send)
  end
end
