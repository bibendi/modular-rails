# frozen_string_literal: true

module CoreBy
  class User < BaseRecord
    extend AttachmentsVariants

    include SoftDeletable
    include WithExternalNanoId

    %i[login email phone].each do |stripped_column|
      attribute stripped_column, :stripped_string
    end

    has_paper_trail

    has_person_name

    has_one_attachment :avatar, variants: {
      basic: {resize_to_fit: [2 * 200, 2 * 200]},
      large: {resize_to_fit: [2 * 1080, 2 * 1080]},
      small: {resize_to_fit: [2 * 128, 2 * 128]},
      thumb: {resize_to_fit: [2 * 64, 2 * 64]}
    }

    enum role: {
      member: "member",
      manager: "manager",
      admin: "admin"
    }.freeze

    enum membership_state: {
      active_membership: "active",
      disabled: "disabled"
    }.freeze

    validates :login, allow_blank: true, length: {in: 3..32}, format: {with: /\A(?!.*\.\.)(?!.*\.$)[^\W][\w.]+\z/}
    validates :email, allow_blank: true, "core_by/email": true
    validates :phone, allow_blank: true, phone: {types: :mobile}

    validates_db_uniqueness_of :phone, index_name: :index_users_on_phone
    validates_db_uniqueness_of :login, case_sensitive: false, index_name: :index_users_on_login
    validates_db_uniqueness_of :email, case_sensitive: false, index_name: :index_users_on_email

    scope :managers, -> { where(role: %w[manager admin]) }
    scope :members, -> { where(role: "member") }
    scope :ordered, -> { order(login: :asc) }
    # members who currently can use the app
    scope :active, -> { where(membership_state: "active_membership").kept }
    scope :active_members, -> { members.active }
    scope :active_managers, -> { managers.active }

    class << self
      def find_by_login(login)
        return if login.blank?

        where(arel_table[:login].lower.eq(login.downcase)).first
      end

      def find_by_login!(login)
        find_by_login(login) || raise(ActiveRecord::RecordNotFound)
      end

      def find_by_email(email)
        return if email.blank?

        where(arel_table[:email].lower.eq(email.downcase)).first
      end

      def find_by_email!(email)
        find_by_email(email) || raise(ActiveRecord::RecordNotFound)
      end

      def normalize_phone(phone)
        phone.is_a?(String) ? Phonelib.parse(phone).e164 : nil
      end

      def find_by_phone(phone)
        phone = normalize_phone(phone)
        return if phone.blank?

        where(arel_table[:phone].eq(phone)).first
      end

      def find_by_phone!(phone)
        find_by_phone(phone) || raise(ActiveRecord::RecordNotFound)
      end
    end

    def active?
      !disabled? && && !discarded?
    end

    def community_manager?
      admin? || manager?
    end

    def phone=(value)
      super self.class.normalize_phone(value)
    end

    def disable!
      update!(membership_state: "disabled")
    end
  end

  ActiveSupport.run_load_hooks("core_by/user", User)
end
