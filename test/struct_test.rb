# encoding: UTF-8
require 'abstract_unit'

module StructTest
  class Struct < ActionWebService::Struct
    member :id, Integer
    member :name, String
    member :items, [String]
    member :deleted, :bool
    member :emails, [:string]
  end
end

class TC_Struct < Test::Unit::TestCase
  include StructTest

  def setup
    @struct = Struct.new(:id      => 5,
                         :name    => 'hello',
                         :items   => ['one', 'two'],
                         :deleted => true,
                         :emails  => ['test@test.com'])
  end

  def test_members
    assert_equal(5, Struct.members.size)
    assert_equal(Integer, Struct.members[:id][0].type_class)
    assert_equal(String, Struct.members[:name][0].type_class)
    assert_equal(String, Struct.members[:items][0].element_type.type_class)
    assert_equal(TrueClass, Struct.members[:deleted][0].type_class)
    assert_equal(String, Struct.members[:emails][0].element_type.type_class)
  end

  def test_initializer_and_lookup
    assert_equal(5, @struct.id)
    assert_equal('hello', @struct.name)
    assert_equal(['one', 'two'], @struct.items)
    assert_equal(true, @struct.deleted)
    assert_equal(['test@test.com'], @struct.emails)
    assert_equal(5, @struct['id'])
    assert_equal('hello', @struct['name'])
    assert_equal(['one', 'two'], @struct['items'])
    assert_equal(true, @struct['deleted'])
    assert_equal(['test@test.com'], @struct['emails'])
  end
  
  def test_initializing_with_invalid_hash_and_not_checking

    attrib_hash = { :id      => 5,
                    :name    => 'hello',
                    :items   => ['one', 'two'],
                    :deleted => true,
                    :emails  => ['test@test.com'],
                    :extra   => "extra_field"
                  }
                                
    assert_raise NoMethodError do
      struct = Struct.new(attrib_hash)
    end
  end
  
  def test_initializing_with_invalid_hash_and_with_hash_checking

     attrib_hash = { :id      => 5,
                     :name    => 'hello',
                     :items   => ['one', 'two'],
                     :deleted => true,
                     :emails  => ['test@test.com'],
                     :extra   => "extra_field"
                   }

     assert_nothing_raised do
        struct = Struct.new(attrib_hash, true)
     end
     struct = Struct.new(attrib_hash, true)
     assert_equal(5, struct['id'])
   end

  def test_each_pair
    @struct.each_pair do |name, value|
      assert_equal @struct.__send__(name), value
      assert_equal @struct[name], value
    end
  end
end
