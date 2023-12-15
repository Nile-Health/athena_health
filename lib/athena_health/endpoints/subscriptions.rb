# frozen_string_literal: true

module AthenaHealth
  module Endpoints
    module Subscriptions
      SUBSCRIPTION_TYPES = [
        {
          collection_class: 'AppointmentCollection',
          path: 'appointments',
          name: 'appointment',
          plural_name: 'appointments',
          verb: "changed"
        },
        {
          collection_class: 'PatientCollection',
          path: 'patients',
          name: 'patient',
          plural_name: 'patients',
          verb: "changed"
        },
        {
          collection_class: 'ProviderCollection',
          path: 'providers',
          name: 'provider',
          plural_name: 'providers',
          verb: "changed"
        },
        {
          collection_class: 'PatientProblemCollection',
          path: 'chart/healthhistory/problems',
          name: 'patient_problem',
          plural_name: 'patient_problems',
          verb: "changed"
        },
        {
          collection_class: 'UserAllergyCollection',
          path: 'chart/healthhistory/allergies',
          name: 'patient_allergy',
          plural_name: 'patient_allergies',
          verb: "changed"
        },
        {
          collection_class: 'PrescriptionCollection',
          path: 'prescriptions',
          name: 'prescription',
          plural_name: 'prescriptions',
          verb: "changed"
        },
        {
          collection_class: 'UserMedicationCollection',
          path: 'chart/healthhistory/medication',
          name: 'patient_medication',
          plural_name: 'patient_medications',
          verb: "changed"
        },
        {
          collection_class: 'PrescriptionCollection',
          path: 'prescriptions',
          name: 'prescription',
          plural_name: 'prescriptions',
          verb: "changed"
        },
        {
          collection_class: 'Claim::ClaimCollection',
          path: 'claims',
          name: 'claim',
          plural_name: 'claims',
          verb: "changed"
        },
        {
          collection_class: 'OrderCollection',
          path: 'orders',
          name: 'orders_created',
          plural_name: 'orders',
          verb: "changed"
        },
        {
          collection_class: 'OrderCollection',
          path: 'orders',
          name: 'orders_signed_off',
          plural_name: 'orders',
          verb: "signedoff"
        }
      ].freeze

      SUBSCRIPTION_TYPES.each do |subscription_type|
        define_method("#{subscription_type[:name]}_subscription") do |practice_id:, params: {}|
          response = @api.call(
            endpoint: "#{practice_id}/#{subscription_type[:path]}/#{subscription_type[:verb]}/subscription",
            method: :get,
            params: params
          )

          Subscription.new(response)
        end

        define_method("create_#{subscription_type[:name]}_subscription") do |practice_id:, params: {}|
          @api.call(
            endpoint: "#{practice_id}/#{subscription_type[:path]}/#{subscription_type[:verb]}/subscription",
            method: :post,
            params: params
          )
        end

        define_method("changed_#{subscription_type[:plural_name]}") do |practice_id:, department_id: nil, params: {}|
          params[:departmentid] = department_id unless department_id.nil?
          response = @api.call(
            endpoint: "#{practice_id}/#{subscription_type[:path]}/#{subscription_type[:verb]}",
            method: :get,
            params: params
          )
          Object.const_get('AthenaHealth').const_get((subscription_type[:collection_class]).to_s).new(response)
        end
      end
    end
  end
end
