require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  let!(:project_example0) { create(:project) }
  let!(:project_example) do
    create(:project) do |project|
      create_list :todo, 4, project: project
    end
  end


  describe 'Create todo' do
    context 'to existing project' do
      let(:todo_with_old_project) { {todo: { text: 'Awesome task', project_id: project_example.id } } }
      before { post '/todos', params: todo_with_old_project }
      it 'saves correctly' do
        expect(json['text']).to eq('Awesome task')
        expect(Project.last.todos.count).to eq(5)
      end
      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with new project' do
      let(:todo_with_new_project) { {todo: { text: 'Excellent task',
                                             project_id: nil,
                                             is_new_project: true,
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

    context 'with new project - invalid params' do
      let(:todo_with_new_project) { {todo: { text: 'Excellent task',
                                             project_id: nil,
                                             is_new_project: false,
                                             new_project_title: 'Totally new project (err)' } } }
      before { post '/todos', params: todo_with_new_project }
      it 'does not creates new project' do
        expect(Project.last[:title]).not_to eq('Totally new project (err)')
      end
      it 'does not saves todo' do
        expect(json['text']).to eq(nil)
      end
      it 'returns error message' do
        expect(json['message']).to eq('You did something wrong')
      end
      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'Check todo' do
    context 'for valid todo' do
      let(:todo_example) { project_example.todos.first }
      let(:todo_example_state) { todo_example.isCompleted }
      before do
        patch "/projects/#{project_example.id}/todos/#{todo_example.id}"
      end
      it 'swaps status' do
        expect(json['state']).not_to eq(todo_example_state)
      end
      it 'returns new state' do
        expect(json['state']).to eq(true).or eq(false)
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
      before { patch "/projects/#{Project.last.id + 1000}/todos/#{Todo.last.id + 1000}" }
      it_behaves_like 'update failed'
    end

    context 'for invalid combination of ids' do
      before { patch "/projects/#{Project.first.id}/todos/#{Project.last.todos.first.id}" }
      it_behaves_like 'update failed'
    end
  end
end
