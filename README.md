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

#### article#index: controller
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

#### article#index: display collection

```rb
<% @articles.each do |article| %>
...
<% end %>
```
