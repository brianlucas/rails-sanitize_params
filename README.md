rails.sanitize-params
=====================

With Rails 4+ strong parameters, helps sanitize params against XSS vulnerabilities.

## Instructions
On Rails, place sanitize_parameters.rb inside your config/initializers directory.  On other stacks, include normally where appropriate.

## Rails usage
```ruby
        def filtered_params

          begin
            params.reverse_merge! ActiveSupport::JSON.decode(request.body.string)
          rescue Exception=>e
          end
          params.sanitize_parameters!
          params.permit(:user_id, :email, :password)
        end
```        
        

## To-Do
create gemfile