class Dependency < ApplicationRecord
    validate :check_parent_and_child_not_equal

    private
        def check_parent_and_child_not_equal
            errors.add(:parent, "a task cannot be dependent on itself") if parent == child
        end
end
