class TasksController < ApplicationController

    def index
        @tasks = Task.all

        @task_dependencies = {}

        @tasks.each do |task|
            @task_dependencies[task] = []

            # Is this task dependent on any other tasks? if so, break
            Dependency.all.each do |dep|
                if task.id == dep.child
                    parent_task = Task.find(dep.parent)
                    @task_dependencies[task].push(parent_task)
                end
            end
        end
    end

    def show
        @task = Task.find(params[:id])
    end

    def new
        @task = Task.new
    end

    def edit
        @task = Task.find(params[:id])
    end

    def create
        @task = Task.new(task_params)

        if @task.save
            redirect_to tasks_path
        else
            flash.now[:error] = "Could not save task"
            render :new
        end
    end

    def update
        @task = Task.find(params[:id])

        if @task.update(task_params)
            redirect_to @task
        else
            render 'edit'
        end
    end

    def destroy
        @task = Task.find(params[:id])
        @task.destroy

        redirect_to tasks_path
    end

    def schedule
        tasks = Task.all
        dependencies = Dependency.all

        @visited = []
        queue = []

        # Get total number of tasks
        total_duration_days = 0
        tasks.each do |task|
            total_duration_days += task.duration
        end

        @total_duration_weeks = (total_duration_days/5.to_f).ceil

        # Add all tasks without dependencies to the queue
        tasks.each do |task|
            has_dependency = false

            # Is this task dependent on any other tasks? if so, break
            dependencies.each do |dep|
                if task.id == dep.child
                    has_dependency = true
                    break
                end
            end

            if has_dependency
                next
            end

            queue.push(task)
            @visited.push(task)
        end

        # Do BFS on remaining tasks to find the right order
        # JUST KIDDING: do topological sort
        while queue.length > 0
            task = queue.shift

            # Remove edges
            dependencies = dependencies.select {|dep| task.id != dep.parent}

            tasks.each do |task|
                if !@visited.include?(task)
                    has_dependency = false

                    dependencies.each do |dep|
                        if task.id == dep.child
                            has_dependency = true
                            break
                        end
                    end

                    if has_dependency
                        next
                    end

                    queue.push(task)
                    @visited.push(task)
                end
            end
        end
    end

    private
        def task_params
            params.require(:task).permit(:name, :duration)
        end
end
