# -*- coding: utf-8 -*-
FactoryGirl.define do
    factory :surface_image do
      sequence(:id)
      surface_id nil
      image_id nil
    end
end