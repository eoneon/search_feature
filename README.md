== README

# Search Feature v2
This version update the search form inputs from checkboxes to a text field. Rather than setting scope names in the form inside a hash named "methods" for the purpose of calling the scopes via `send_chain`, I wanted to pass in both the scope names and scope arguments.

## Issue
While I'm able to pass in scope names, I can't figure out how to pass in scope arguments. Apparently the param hash is not available to the model. I'm also unable to pass the param hash through a method for the purposes of calling it as an argument in the scope.

I think I could overcome this by creating a separate search model given there would be an actual search object I could reference in the database. I also wonder if I could call all scopes chained together on a single line and then just use `unless blank?` conditions for each. Would that break the chain I wonder? I could do the same inside the controller and chain only on the condition that the attribute wasn't blank.

I could just insert this into a helper method. I could just call the scope there.

```rb
<%= form_tag("/articles", method: "get") do %>
  <%= label_tag(:author, "Author's name:") %>
  <%= text_field_tag (:author) %>
  <%= submit_tag("Search") %>
<% end %>
```

#### article#index: controller
```rb
class ArticlesController < ApplicationController
  def index
    if params[:article]
      params_hsh = params[:article]
      @articles = Article.send_chain(params_hsh)
    else
      @articles = Article.all
    end
  end
end
```

#### Create the Scopes Inside the Model
```rb
class Article < ActiveRecord::Base
  scope :with_author, -> { where(author: "Gunnar") }
  ...
end
```

```rb
class Article < ActiveRecord::Base
  ...
  def get_hash(params_hsh)
    params_hsh.delete_if { |k, v| v.nil? }
  end

  #call chained scopes
  def self.send_chain(get_hash)
    hsh = get_hash.keys.map { |k| "with_" + k }
    hsh.inject(self, :send)
  end
```
