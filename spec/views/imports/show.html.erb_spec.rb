require 'rails_helper'

RSpec.describe "imports/show", type: :view do
  before(:each) do
    @import = assign(:import, Import.create!(
      data: "Data"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Data/)
  end
end
