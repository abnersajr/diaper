# == Schema Information
#
# Table name: tickets
#
#  id           :integer          not null, primary key
#  comment      :text
#  created_at   :datetime
#  updated_at   :datetime
#  inventory_id :integer
#  partner_id   :integer
#

FactoryGirl.define do
  factory :ticket do
    inventory
    partner

    trait :with_items do
      inventory { create :inventory, :with_items }

      transient do
        item_quantity 100
        item nil
      end

      after(:build) do |ticket, evaluator|
        item = if evaluator.item.nil?
                 ticket.inventory.holdings.first.item
               else
                 evaluator.item
               end
        ticket.containers << build(:container, quantity: evaluator.item_quantity, item: item)
      end
    end
  end
end