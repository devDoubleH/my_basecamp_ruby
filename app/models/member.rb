class Member < ApplicationRecord

  validates :email, uniqueness: { scope: :project_id }, presence: true

  belongs_to :project

  def self.find_by_email(user)
    projects = Member.where(:email => user.email).map do |elem|
      elem.project.member = elem
      elem.project.css_class = "member"
      elem.project.owner = elem.project.user.name
      elem.project.is_owner = false
      elem.project.is_admin = elem.is_admin
      elem.project.num_members = elem.project.members.count
      elem.project.num_topics = elem.project.topics.count
      elem.project
    end
    return projects
  end

  def self.change_permissions_to_true(email)
    member = Member.where(:email => email)
    member.update(:can_read => true)
    member.update(:can_write => true)
    member.update(:can_update => true)
    member.update(:can_delete => true)
  end

  def self.change_permissions_to_false(email)
    member = Member.where(:email => email)
    member.update(:can_read => false)
    member.update(:can_write => false)
    member.update(:can_update => false)
    member.update(:can_delete => false)
  end

end
