require 'spec_helper'

describe "crops/show" do
  before(:each) do
    @crop = assign(:crop, stub_model(Crop,
      :id => 1,
      :system_name => "Corn",
      :en_wikipedia_url => "http://en.wikipedia.org/Maize"
    ))
    @crop.scientific_names.create(
      :scientific_name => "Zea mays",
      :crop_id => 1
    )
  end

  it "shows the wikipedia URL" do
    render
    assert_select("a[href=#{@crop.en_wikipedia_url}]", 'Wikipedia (English)')
  end

  it "shows the scientific name" do
    render
    rendered.should contain "Scientific names"
    rendered.should contain "Zea mays"
  end

  it "shows a plant this button" do
    render
    rendered.should contain "Plant this"
  end

  it "links to the right crop in the planting link" do
    render
    assert_select("a[href=#{new_planting_path}?crop_id=1]")
  end

  context "logged out" do
    it "doesn't show the edit links if logged out" do
      render
      rendered.should_not contain "Edit"
    end
  end

  context "logged in" do

    before(:each) do
      @user = User.create(:email => "growstuff@example.com", :password => "irrelevant")
      @user.confirm!
      sign_in @user
      render
    end

    it "links to the edit crop form" do
      rendered.should contain "Edit"
    end
  end

end
