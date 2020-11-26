require 'rails_helper'

RSpec.describe "imports/index", type: :view do
  before(:each) do
    assign(:imports, [
      Import.create!(
        data: "Data"
      ),
      Import.create!(
        data: "Data"
      )
    ])
  end

  it "renders a list of imports" do
    render
    assert_select "tr>td", text: "Data".to_s, count: 2
  end
end
