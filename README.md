# ensure_param_exists

Provide an easy way to verify you're receiving the correct parameters in an API request in Rails.

At PetroFeed we found that we were repeatedly writing the following code in our controllers:

```ruby
class ArticleController
  before_filter :ensure_title_exists

  private

    def ensure_title_exists
      return unless params[:title].blank?
      render json: { success: false, message: "missing title parameter" }, status: 422
    end
end
```

To keep our controllers DRY we created the `ensure_param` gem which allows us to do the following:


```ruby
class ArticleController
  ensure_param :title
end
```

Classy! Cut that duplicate code and keep your controllers DRY! :hocho:

Installation
----

```ruby
gem install ensure_param_exists
```

Usage
----

Add ensure_param_exists to your gemfile:

```ruby
gem 'ensure_param_exists'
```

Mixin the functionality into a controller (or base controller):

```ruby
class ArticleController
  include EnsureParamExists

  # ...
end
```

Define any parameters that you'd like check to make sure they exist with `ensure_param`. The method takes a symbol and any options that you'd pass to before_filter

```ruby
class ArticleController
  include EnsureParamExists

  ensure_param :title, only: [:show]
  ensure_param :author, except: [:index, :create]
end
```

`ensure_any_params` validates that at least one param exists (an **or** filter).

## Copyright

Copyright (c) 2013 PetroFeed. See [LICENSE](https://github.com/PetroFeed/ensure_param_exists/blob/master/LICENSE) for further details.

---

Proudly brought to you by [PetroFeed](http://PetroFeed.com).

![Pedro](https://www.petrofeed.com/img/company/pedro.png)
