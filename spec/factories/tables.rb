# -*- coding: utf-8 -*-
FactoryGirl.define do
    factory :table do
      sequence(:id)
      bib_id nil
      title "great paper"
    end
end