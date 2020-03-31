require 'test_helper'

class UserTest < ActiveSupport::TestCase
  let(:user) { users(:user1) }

  describe 'associations' do
    it 'has many cards_lists' do
      _(user).must(have_many(:card_lists).autosave(true).dependent(:destroy).inverse_of(:user))
    end

    it 'has many collections' do
      _(user).must(have_many(:collections).dependent(:destroy).inverse_of(:user))
    end

    it 'has many cards through collections' do
      _(user).must(have_many(:cards).through(:collections))
    end
  end

  describe 'validations' do
    describe 'username' do
      it 'valdiates format of username' do
        _(user).must(allow_value('testtesttest').for(:username))
        _(user).must(allow_value('TeStTeSt').for(:username))
        _(user).must(allow_value('test12345').for(:username))
        _(user).must(allow_value('test_1').for(:username))
        _(user).must(allow_value('test__').for(:username))
        _(user).wont(allow_value('te').for(:username))
        _(user).wont(allow_value('test' * 10).for(:username))
        _(user).wont(allow_value('__test').for(:username))
        _(user).wont(allow_value('1__test').for(:username))
      end

      it 'validates presence of username' do
        _(user).must(validate_presence_of(:username))
      end

      it 'validates uniqueness of username' do
        _(user).must(validate_uniqueness_of(:username))
      end
    end

    describe 'email' do
      it 'validates that email is an email address' do
        _(user).must(allow_value('test@test.com').for(:email))
        _(user).wont(allow_value('test').for(:email))
        _(user).wont(allow_value('test@').for(:email))
        _(user).wont(allow_value('@test.com').for(:email))
      end

      it 'validates presence of email' do
        _(user).must(validate_presence_of(:email))
      end
    end
  end

  describe '#full_name' do
    it 'returns a combination of the user\'s first and last name' do
      user.first_name = 'TEST'
      user.last_name = 'USER'

      _(user.full_name).must_equal('TEST USER')
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

      _(user.default_list).must_equal(card_list_2)
    end
  end
end
