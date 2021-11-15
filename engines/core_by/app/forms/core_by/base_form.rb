# frozen_string_literal: true

require "active_model"
require "active_model/attributes"
require "active_support/callbacks"

module CoreBy
  # Base class for form objects.
  #
  # Allows you do save models with
  # form-specific validations, and define form-specific callbacks.
  #
  # Example:
  #
  #   class PasswordResetForm < CoreBy::BaseForm
  #     attributes :token, :new_password
  #
  #     validates :token, :new_password, presence: true
  #
  #     # Define #persist! method to submit the form
  #     def persist!
  #       user = User.find_by!(reset_password_token: token)
  #       user.update_password(new_password)
  #     end
  #   end
  class BaseForm
    include ActiveModel::Model
    include ActiveSupport::Callbacks
    include ActiveModel::Attributes
    include AfterCommitEverywhere

    define_callbacks :save

    class << self
      # Define form input params.
      #
      # All params stored in the `attributes` Hash,
      # this method defines accessors.
      #
      # The attributes list is stored in the class to
      # be used in generating filtering data for strong parameters.
      def attributes(*attrs)
        attrs.each do |name|
          attribute name
        end
      end

      def attribute(name, type = ActiveModel::Type::Value.new, **options)
        super
        # Add predicate methods for boolean types
        alias_method :"#{name}?", name if type == :boolean || type.is_a?(ActiveModel::Type::Boolean)
      end

      def after_save(*args, &block)
        set_callback :save, :after, *args, &block
      end
    end

    def save
      return false unless valid?

      !!with_transaction do
        run_callbacks(:save) do
          val = persist!
          if val.is_a?(FalseClass)
            raise ActiveRecord::Rollback
          else
            true
          end
        end
      end
    end

    def save!
      save || raise(ActiveModel::ValidationError.new(self))
    end

    def with_transaction
      ActiveRecord::Base.transaction { yield }
    end

    def persist!
      raise NotImplementedError, "Method #{self.class.name}#persist! must be defined"
    end

    # Merge errors from other record to form errors
    # Useful if you want to combine model errors
    # with form errors.
    #
    #   validate :validate_model
    #
    #   def validate_model
    #     return if model.valid?
    #
    #     merge_errors!(model)
    #   end
    def merge_errors!(other)
      errors.merge!(other.errors)
    end
  end
end
