# frozen_string_literal: true

shared_examples_for 'Voted' do
  sign_in_user

  describe 'POST #vote_for' do
    before { |e| post :vote_for, params: { id: votable.id, format: :json } unless e.metadata[:skip_before] }

    context 'Non-author tries to vote' do
      it('assigns the requested votable to @votable') { expect(assigns(:votable)).to eq votable }

      it 'creates a new vote', :skip_before do
        expect do
          post :vote_for, params: { id: votable.id, format: :json }
        end.to change(votable.votes, :count).by(1)
      end

      it('checks that value of vote to equal 1') { expect(assigns(:vote).value).to eq 1 }
    end

    context 'Author tries to vote' do
      it 'does not create a new vote', :skip_before do
        expect do
          post :vote_for, params: { id: votable_of_user.id, format: :json }
        end.to_not change(votable_of_user.votes, :count)
      end
    end

    context 'Non-author tries to vote 2 times' do
      it 'does not create a new vote' do
        expect do
          post :vote_for, params: { id: votable.id, format: :json }
        end.to_not change(votable.votes, :count)
      end
    end
  end

  describe 'POST #vote_against' do
    before { |e| post :vote_against, params: { id: votable, format: :json } unless e.metadata[:skip_before] }

    context 'non-author tries to vote' do
      it('assigns the requested votable to @votable') { expect(assigns(:votable)).to eq votable }

      it 'creates a new vote', :skip_before do
        expect do
          post :vote_against, params: { id: votable.id, format: :json }
        end.to change(votable.votes, :count).by(1)
      end

      it('checks that value of vote to equal -1') { expect(assigns(:vote).value).to eq(-1) }
    end

    context 'author tries to vote' do
      it 'does not create a new vote', :skip_before do
        expect do
          post :vote_against, params: { id: votable_of_user.id, format: :json }
        end.to_not change(votable_of_user.votes, :count)
      end
    end

    context 'Non-author tries to vote 2 times' do
      it 'does not create a new vote' do
        expect do
          post :vote_for, params: { id: votable.id, format: :json }
        end.to_not change(votable.votes, :count)
      end
    end
  end

  describe 'DELETE #re_vote' do
    let(:vote_of_author) { create(:vote, votable: votable, user: @user) }
    let(:vote)           { create(:vote, votable: votable) }

    context 'author of vote tries to re-vote' do
      it 'assigns the requested votable to @votable' do
        delete :re_vote, params: { id: votable.id, format: :json }
        expect(assigns(:votable)).to eq votable
      end

      it 'destroys the vote of author' do
        vote_of_author
        expect do
          delete :re_vote, params: { id: votable.id, format: :json }
        end.to change(votable.votes, :count).by(-1)
      end
    end

    context 'Non-author of vote tries to re-vote' do
      it 'does not destroy the vote' do
        vote
        expect do
          delete :re_vote, params: { id: votable.id, format: :json }
        end.to_not change(votable.votes, :count)
      end
    end
  end
end
