feature 'Student interface', :devise do

  before(:each) do
    @user = FactoryGirl.create :user, :with_batch
     signin(@user.rut, @user.password)
  end

  context "apply" do



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


    scenario "shows next block from open blocks pool after saving course order" do
      click_on "Next block"
      expect(current_path).to eq "/apply/#{@user.course_batch_id}/#{@user.course_batch.blocks.second.id}"
    end

    scenario "shows error if block is closed" do
      @user.course_batch.open_status = false
      @user.course_batch.save
      visit apply_path(@user.course_batch, @user.course_batch.blocks.first)
      expect(page).to have_content("This block is closed")
    end

  end

  context "results" do


    scenario "shows results after ordering all blocks" do
      expect(@user.course_batch.blocks.count).to eq 3
      @user.course_batch.blocks.each do |block|
        unless block == @user.course_batch.blocks.last
          click_on "Next block"
          expect(current_path).to eq "/apply/#{@user.course_batch_id}/#{@user.course_batch.blocks[@user.course_batch.blocks.index(block)+1].id}"
        else
          click_on "Summary"
        end
      end
      expect(current_path).to eq summary_path

      expect(all(".application-row").count).to eq @user.applications.count
      # within("#idle-student-row-#{@users.first.id}") do
      #   expect(page).to have_content @users.first.rut
      #   expect(page).to have_content @users.first.name
      #   expect(page).to have_content @users.first.sign_in_count
      #   expect(page).to have_content @users.first.last_sign_in_at
      # end
    end


  end

end