# frozen_string_literal: true

admin_user = User.new(first_name: 'Peter', last_name: 'Zhu',
                      email: 'peter@peterzhu.ca', password: 'password', password_confirmation: 'password',
                      user_type: :admin)
admin_user.skip_confirmation_notification!
admin_user.confirm

member_user = User.new(first_name: 'Member', last_name: 'User',
                       email: 'member@uoftcodes.com', password: 'password', password_confirmation: 'password',
                       user_type: :member)
member_user.skip_confirmation_notification!
member_user.confirm
