require 'rails_helper'

RSpec.describe "imports/edit", type: :view do
  before(:each) do
    @import = assign(:import, Import.create!(
      data: "MyString"
    ))
  end

  it "renders the edit import form" do
    render

    assert_select "form[action=?][method=?]", import_path(@import), "post" do

      assert_select "input[name=?]", "import[data]"
    end
  end
end
