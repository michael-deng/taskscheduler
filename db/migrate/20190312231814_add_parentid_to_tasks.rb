class AddParentidToTasks < ActiveRecord::Migration[5.2]
	def change
		add_reference :tasks, :parent, index: true
 	end
end
