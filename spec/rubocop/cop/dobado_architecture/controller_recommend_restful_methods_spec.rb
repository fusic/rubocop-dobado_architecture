# frozen_string_literal: true

RSpec.describe RuboCop::Cop::DobadoArchitecture::ControllerRecommendRestfulMethods, :config do
  example 'RESTfulでないメソッドを検知' do
    expect_offense(<<~RUBY)
      class UsersController < ApplicationController
        def bad_method
            ^^^^^^^^^^ RESTful(index, show, new, edit, create, update, destroy)なメソッド名の使用を推奨します
        end
      end
    RUBY
  end

  example '複数ある場合はすべてを検知する' do
    expect_offense(<<~RUBY)
      class UsersController < ApplicationController
        def bad_method1
            ^^^^^^^^^^^ RESTful(index, show, new, edit, create, update, destroy)なメソッド名の使用を推奨します
        end

        def bad_method2
            ^^^^^^^^^^^ RESTful(index, show, new, edit, create, update, destroy)なメソッド名の使用を推奨します
        end
      end
    RUBY
  end

  example 'publicメソッドのみを検知対象とする' do
    expect_no_offenses(<<~RUBY)
      class UsersController < ApplicationController
        def index
        end

        protected

        def bad_method1
        end

        private

        def bad_method
        end
      end
    RUBY
  end

  example '設定にしたがって検知する' do
    cop_config['RecommendedMethods'] = %w[index]
    expect_offense(<<~RUBY)
      class UsersController < ApplicationController
        def index
        end

        def show
            ^^^^ RESTful(index)なメソッド名の使用を推奨します
        end
      end
    RUBY
  end

  example 'RESTfulなメソッドは検知しない' do
    expect_no_offenses(<<~RUBY)
      class UsersController < ApplicationController
        def index
        end
      end
    RUBY
  end
end
