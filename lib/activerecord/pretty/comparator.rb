# frozen_string_literal: true

require_relative "comparator/version"
require "active_record"

module Activerecord
  module Pretty
    # :nodoc:
    module Comparator
      class Error < StandardError; end
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::PredicateBuilder.prepend(Module.new do
          def [](attr_name, value, operator = nil)
            if !operator && attr_name.end_with?(">", ">=", "<", "<=")
              /\A(?<attr_name>.+?)\s*(?<operator>>|>=|<|<=)\z/ =~ attr_name
              operator = OPERATORS[operator]
            end

            super
          end

          OPERATORS = { ">" => :gt, ">=" => :gteq, "<" => :lt, "<=" => :lteq }.freeze # rubocop:disable Lint/ConstantDefinitionInBlock
        end)
      end
    end
  end
end
