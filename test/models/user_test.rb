require 'test_helper'

class UserTest < ActiveSupport::TestCase
  let(:user) { users(:user1) }

  describe 'associations' do
    it 'has many cards_lists' do
      user.must have_many(:card_lists).autosave(true).dependent(:destroy).inverse_of(:user)
    end

    it 'has many collections' do
      user.must have_many(:collections).dependent(:destroy).inverse_of(:user)
    end

    it 'has many cards through collections' do
      user.must have_many(:cards).through(:collections)
    end
  end

  describe 'validations' do
    describe 'username' do
      it 'valdiates format of username' do
        user.must allow_value('testtesttest').for(:username)
        user.must allow_value('TeStTeSt').for(:username)
        user.must allow_value('test12345').for(:username)
        user.must allow_value('test_1').for(:username)
        user.must allow_value('test__').for(:username)
        user.wont allow_value('te').for(:username)
        user.wont allow_value('test' * 10).for(:username)
        user.wont allow_value('__test').for(:username)
        user.wont allow_value('1__test').for(:username)
      end

      it 'validates length of username' do
        user.must validate_length_of(:username).is_at_least(5).is_at_most(32)
      end

      it 'validates presence of username' do
        user.must validate_presence_of(:username)
      end

      it 'validates uniqueness of username' do
        user.must validate_uniqueness_of(:username)
      end
    end

    describe 'email' do
      it 'validates that email is an email address' do
        user.must allow_value('test@test.com').for(:email)
        user.wont allow_value('test').for(:email)
        user.wont allow_value('test@').for(:email)
        user.wont allow_value('@test.com').for(:email)
      end

      it 'validates presence of email' do
        user.must validate_presence_of(:email)
      end
    end
  end

  describe '#full_name' do
    it 'returns a combination of the user\'s first and last name' do
      user.first_name = 'TEST'
      user.last_name = 'USER'

      user.full_name.must_equal 'TEST USER'
    end
  end

  describe '#default_list' do
    it 'returns the user\'s default CardList' do
      card_list_1 = CardList.new(name: 'Test 1', have: true, order: 0, default: false)
      card_list_2 = CardList.new(name: 'Test 2', have: true, order: 1, default: true)
      card_list_3 = CardList.new(name: 'Test 3', have: true, order: 2, default: false)

      user.card_lists << card_list_1
      user.card_lists << card_list_2
      user.card_lists << card_list_3

      user.default_list.must_equal card_list_2
    end
  end
end
