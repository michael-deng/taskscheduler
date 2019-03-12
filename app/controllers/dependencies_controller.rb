class DependenciesController < ApplicationController

    def index
        @dependencies = Dependency.all
    end

    def new
        @dependency = Dependency.new
    end

    def edit
        @dependency = Dependency.find(params[:id])
    end

    def create
        # TODO: prevent circular dependencies somehow (potentially do bfs)

        @dependency = Dependency.new(dependency_params)

        if @dependency.save
            redirect_to dependencies_path
        else
            render 'new'
        end
    end

    def update
        @dependency = Dependency.find(params[:id])

        if @dependency.update(dependency_params)
            redirect_to dependencies_path
        else
            render 'edit'
        end
    end

    def destroy
        @dependency = Dependency.find(params[:id])
        @dependency.destroy

        redirect_to dependencies_path
    end

    private
        def dependency_params
            params.require(:dependency).permit(:parent, :child)
        end
end
