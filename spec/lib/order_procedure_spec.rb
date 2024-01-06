require 'spec_helper'

describe AthenaHealth::OrderProcedure do
  let(:order_procedure_attributes) do
    {
      'name': 'colonoscopy (SURG)',
      'ordertypeid': '18628'
    }
  end

  subject { AthenaHealth::OrderProcedure.new(order_procedure_attributes) }

  it_behaves_like 'a model'

  it 'have proper attributes' do
    expect(subject).to have_attributes(
      name: 'colonoscopy (SURG)',
      ordertypeid: 18628
    )
  end
end
