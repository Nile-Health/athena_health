require 'spec_helper'

describe AthenaHealth::Condition do
  let(:condition_attributes) do
    {
      'condition': 'Hypertension',
      'conditionid': '18628'
    }
  end

  subject { AthenaHealth::Condition.new(condition_attributes) }

  it_behaves_like 'a model'

  it 'have proper attributes' do
    expect(subject).to have_attributes(
      condition: 'Asacol',
      conditionid: 18628
    )
  end
end
