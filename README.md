# ensure-param-exists

Provide an easy way to verify you're receiving the correct parameters in an API request.

At PetroFeed we found that we were repeatedly writing the following code in our controllers:

```
class ArticleController
  before_filter :ensure_title_exists

  private

    def ensure_title_exists
      return unless params[:title].blank?
      render json: { success: false, message: "missing title parameter" }, status: 422
    end
end
```

To keep our controllers DRY we created the `ensure-param-exists` gem which allows us to do the following:


```
class ArticleController
  define_ensure_param_exists_for :title
  before_filter :ensure_title_exists
end
```

Classy! Cut that duplicate code and keep your controllers DRY! :hocho:

Installation
----

```
gem install ensure-param-exists
```

Usage
----

Add ensure-param-exists to your gemfile:

```
gem 'ensure-param-exists'
```

Mixin the functionality into a controller (or base controller):

```
class ArticleController
  extend EnsureParamExists

  # ...
end
```

Define any parameters that you'd like to make sure exist with `define_ensure_param_exists_for`. The method takes a symbol or array.

```
class ArticleController
  extend EnsureParamExists

  define_ensure_param_exists_for :title, :author

  before_filter :ensure_title_exists
  before_filter :ensure_author_exists
end
```

## Copyright

Copyright (c) 2013 PetroFeed. See LICENSE.txt for further details.

---

Proudly brought to you by [PetroFeed](http://PetroFeed.com).

![Pedro](https://www.petrofeed.com/img/company/pedro.png)