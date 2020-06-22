require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  let!(:project_example0) { create(:project) }
  let!(:project_example) do
    create(:project) do |project|
      create_list :todo, 4, project: project
    end
  end


  describe 'Create todo' do
    context 'to existing project by id' do
      let(:todo_with_old_project) { {todo: { text: 'Awesome task', project_id: project_example.id } } }
      before { post '/todos', params: todo_with_old_project }
      it 'saves correctly' do
        expect(json['text']).to eq('Awesome task')
        expect(Project.find(project_example.id).todos.count).to eq(5)
      end
      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'to existing project by title' do
      let(:todo_with_pseudo_new_project) { {todo: { text: 'Excellent task',
                                                    project_id: nil,
                                                    new_project_title: project_example.title  } } }
      before { post '/todos', params: todo_with_pseudo_new_project }
      it 'saves correctly' do
        expect(json['text']).to eq('Excellent task')
        expect(Project.find(project_example.id).todos.count).to eq(5)
      end
      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with new project' do
      let(:todo_with_new_project) { {todo: { text: 'Excellent task',
                                             project_id: nil,
                                             new_project_title: 'Totally new project' } } }
      before { post '/todos', params: todo_with_new_project }
      it 'creates new project' do
        expect(Project.last[:title]).to eq('Totally new project')
      end
      it 'saves correctly' do
        expect(json['text']).to eq('Excellent task')
        expect(Project.last.todos.count).to eq(1)
      end
      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

  end

  describe 'Toogle todo' do
    context 'for valid todo' do
      let(:todo_example) { project_example.todos.first }
      let(:todo_example_state) { todo_example.isCompleted }
      before do
        patch "/projects/#{project_example.id}/todos/#{todo_example.id}"
      end
      it 'swaps status' do
        expect(json['isCompleted']).to eq(!todo_example_state)
      end
      it 'returns todo back' do
        expect(json['id']).to eq(todo_example.id)
        expect(json['text']).to eq(todo_example.text)
      end
      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    RSpec.shared_examples 'update failed' do
      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns error message' do
        expect(json['message']).to eq('You did something wrong')
      end
    end

    context 'for non existing todo' do
      before { patch "/projects/#{Project.first.id}/todos/#{Todo.last.id + 1000}" }
      it_behaves_like 'update failed'
    end

    context 'for non existing project' do
      before { patch "/projects/#{Project.last.id + 1000}/todos/#{Todo.last.id}" }
      it_behaves_like 'update failed'
    end

    context 'for non existing project and todo' do
      before { patch "/projects/#{Project.last.id + 1000}/todos/#{Todo.last.id + 1000}" }
      it_behaves_like 'update failed'
    end

    context 'for invalid combination of ids' do
      before { patch "/projects/#{Project.first.id}/todos/#{Project.last.todos.first.id}" }
      it_behaves_like 'update failed'
    end
  end
end
