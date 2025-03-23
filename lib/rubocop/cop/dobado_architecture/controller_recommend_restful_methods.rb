# frozen_string_literal: true

module RuboCop
  module Cop
    # DobadoArchitectureに関するCop
    module DobadoArchitecture
      # コントローラーのアクション名として、RESTfulなメソッド名
      # (index, show, new, edit, create, update, destroy)を推奨するためのCop
      #
      # @example
      #   # bad
      #   class UsersController < ApplicationController
      #     def bad_method; end
      #   end
      #
      #   # good
      #   class UsersController < ApplicationController
      #     def index; end
      #   end
      class ControllerRecommendRestfulMethods < Base
        include DefNode

        MSG = 'RESTful(%<recommended_methods>s)なメソッド名の使用を推奨します'

        # @!method action_declarations(node)
        def_node_search :action_declarations, <<~PATTERN
          (def ...)
        PATTERN

        def on_class(node)
          non_restful_methods(node).each do |action|
            register_offence(action)
          end
        end

        private

        def non_restful_methods(node)
          action_declarations(node).filter do |action|
            next if non_public?(action)

            !recommended_methods.include?(action.method_name)
          end
        end

        def register_offence(node)
          add_offense(node.loc.name, message: format(MSG, recommended_methods: recommended_methods.join(', ')))
        end

        def recommended_methods
          cop_config['RecommendedMethods'].map(&:to_sym)
        end
      end
    end
  end
end
