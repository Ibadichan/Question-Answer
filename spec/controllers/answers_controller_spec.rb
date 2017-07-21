# frozen_string_literal: true

require 'rails_helper'

describe AnswersController do
  sign_in_user
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:answer_of_user) { create(:answer, user: @user, question: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the answer in the database' do
        expect do
          post :create, params: { question_id: question,
                                  answer: attributes_for(:answer), format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'connects the user to the answer' do
        expect do
          post :create, params: { question_id: question,
                                  answer: attributes_for(:answer), format: :js }
        end.to change(@user.answers, :count).by(1)
      end

      it 'render create view' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer), format: :js }
        expect(response).to render_template 'create'
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:invalid_answer),
                                  question_id: question, format: :js }
        end.to_not change(Answer, :count)
      end

      it 'render create view' do
        post :create, params: { answer: attributes_for(:invalid_answer),
                                question_id: question, format: :js }
        expect(response).to render_template 'create'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author tries to delete his answer' do
      it 'deletes the @answer' do
        answer_of_user
        expect do
          delete :destroy, params: { id: answer_of_user,
                                     format: :js }
        end.to change(Answer, :count).by(-1)
      end

      it 'render template  delete' do
        delete :destroy, params: { id: answer_of_user, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Not-author tries to delete  answer' do
      it 'does not delete the @answer' do
        answer
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'Author tries to update answer' do
      it 'assigns question of answer to @question' do
        patch :update, params: { id: answer_of_user, question_id: question,
                                 answer: attributes_for(:answer), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'assigns requested answer to @answer' do
        patch :update, params: { id: answer_of_user, question_id: question,
                                 answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer_of_user
      end

      it 'changes the attributes of answer' do
        patch :update, params: { id: answer_of_user, question_id: question,
                                 answer: { body: 'new body' }, format: :js }
        answer_of_user.reload
        expect(answer_of_user.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: answer_of_user, question_id: question,
                                 answer: attributes_for(:answer), format: :js }
        expect(response).to render_template 'update'
      end
    end

    context 'Non author tries to update answer' do
      it 'does not change attributes of answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'PATCH #best' do
    let(:question_of_user) { create(:question, user: @user) }
    let(:answer_of_question) { create(:answer, question: question_of_user) }

    context 'Author tries to select best answer' do
      before { patch :best, params: { id: answer_of_question, format: :js } }

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq answer_of_question
      end

      it 'assigns question of answer to @question' do
        expect(assigns(:question)).to eq question_of_user
      end

      it "changes value of field 'best' to true" do
        answer_of_question.reload
        expect(answer_of_question).to be_best
      end

      it 'render best view' do
        expect(response).to render_template 'best'
      end
    end

    context 'Non-author tries to select best answer' do
      it "does not change value of field 'best' to true" do
        expect do
          patch :best, params: { id: answer, format: :js }
        end.to_not change { answer.reload.best }
      end
    end
  end
end
