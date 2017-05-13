== README

# This is a test for building a search feature using scopes.
## User Flow
From the `articles#index` view, a user fills in the checkbox form to filter an index of articles. When the user **submits** the form data, the request is routed to the `/articles` path, which in turn maps it to the Article controller. If the params hash is empty, the controller retrieves all articles. But if params evaluates `true`, the action extract the keys from the params hash in order to pass them as arguments to `send_chain`. The `send_chain` method iterates over the array of keys using `inject`, which evaluates them as a chained scope. The results are cashed in an instance variable for displaying on the index view.

#### article#index: form

```rb
<%= form_tag("/articles", method: "get") do %>
  With Author<%= check_box_tag "article[methods][]", "with_author"  %>
  Pending Review<%= check_box_tag "article[methods][]", "pending_review"  %>
  Draft<%= check_box_tag "article[methods][]", "draft"  %>
  Flagged<%= check_box_tag "article[methods][]", "flagged"  %>
  Published<%= check_box_tag "article[methods][]", "published"  %>
  With Website<%= check_box_tag "article[methods][]", "with_website"  %>
  With Meta Title<%= check_box_tag "article[methods][]", "with_meta_title"  %>
  With Meta Description<%= check_box_tag "article[methods][]", "with_meta_description"  %>
 <%= submit_tag("Search") %>
<% end %>
```

#### The params hash
The params hash looks like this:
```rb
params #=>
{
  "utf8"=>"✓",
  "article"=>
    {
      "methods"=> ["with_author", "pending_review"]
    },
  "commit"=>"Search",
  "controller"=>"articles",
  "action"=>"index"
}
```

Going one level down, we can extract the article params like this:
```rb
params[:article] #=> {"methods"=>["with_author", "pending_review"]}
```

Finally, dropping down another level we can extract the array of keys like this:
```rb
params[:article][:methods] #=> ["with_author", "pending_review"]
```
>This is wrong. The reference to `methods` does not extract the keys of the params hash. Methods comes from the form where we create our searches. The parameters are assigned to article[methods], where the `methods` hash accepts the checkbox value entered by the user.
>In Blocit and the rest of my apps, I used `name="model[attribute]"` to accept the attribute value. Because the name of the scope does not correspond to this value, we can't use it alone to call our scopes.
#### article#index: controller
```rb
class ArticlesController < ApplicationController
  def index
    if params[:article]
      methods = params[:article][:methods]
      @articles = Article.send_chain(methods)
    else
      @articles = Article.all
    end
  end
end
```

#### Create the Scopes Inside the Model
```rb
class Article < ActiveRecord::Base
  enum status: [ :draft, :pending_review, :flagged, :published]

  #note: the WHERE clause is passed in as an argument
  #thus we only need the name of the method (key) and not the value for the second method below
  scope :with_author, -> {(where("'author' IS NOT NULL ")) }
  scope :with_website, -> {(where("'website' IS NOT NULL ")) }
  scope :with_meta_title, -> {(where("'meta_title' IS NOT NULL ")) }
  scope :with_meta_description, -> {(where("'meta_description' IS NOT NULL ")) }

  def self.send_chain(methods)
    ...
  end
end
```
#### Call the scopes using inject and send
```rb
class Article < ActiveRecord::Base
  ...
  def self.send_chain(methods)
    #methods: arguments from the controller which correspond to scope names
    #inject: iterates over arguments, and for each string item (self) evaluate using send
    #returns a chained scope
    methods.inject(self, :send)
  end
end
```

#### article#index: display collection

```rb
<% @articles.each do |article| %>
...
<% end %>
```

## Next:
Modify project by making the scopes dynamic so that a user may manually enter search values. I don't think I need to have a search model. I think all I have to do is pass in the values along with the keys.
