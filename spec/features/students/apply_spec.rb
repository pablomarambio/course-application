feature 'Student interface', :devise do

  context "apply" do

    before(:each) do
      @user = FactoryGirl.create :user, :with_batch
       signin(@user.rut, @user.password)
    end

    scenario "creates  or loads application object for each course on first visit" do
      expect(@user.applications).to eq Application.where(user_id:@user.id).select{|a| @user.course_batch.blocks.first.courses.include?(a.course)}
    end


    scenario "allows to move a course up" do
      @first_application = @user.applications_for_block(@user.course_batch.blocks.first).first
      @second_application = @user.applications_for_block(@user.course_batch.blocks.first).second
      within("#application-#{@second_application.id}-#{@second_application.priority}") do
        click_link "up-#{@second_application.id}"
      end
      expect(current_path).to eq "/apply/#{@user.course_batch_id}/#{@user.course_batch.blocks.first.id}"
      within("#application-#{@first_application.id}-#{@second_application.priority}") do
        expect(page).to have_content @first_application.course.name
      end
    end

    scenario "allows to move a course down" do
        @first_application = @user.applications_for_block(@user.course_batch.blocks.first).first
        @second_application = @user.applications_for_block(@user.course_batch.blocks.first).second
        within("#application-#{@first_application.id}-#{@first_application.priority}") do
          click_link "down-#{@first_application.id}"
        end
        expect(current_path).to eq "/apply/#{@user.course_batch_id}/#{@user.course_batch.blocks.first.id}"
        within("#application-#{@second_application.id}-#{@first_application.priority}") do
          expect(page).to have_content @second_application.course.name
        end
      end


    scenario "shows next block from open blocks pool after saving course order"

    scenario "shows error if block is closed"

    scenario "shows results after ordering all blocks"

  end

end