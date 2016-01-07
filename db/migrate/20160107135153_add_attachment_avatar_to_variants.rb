class AddAttachmentAvatarToVariants < ActiveRecord::Migration
  def self.up
    change_table :variants do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :variants, :avatar
  end
end
