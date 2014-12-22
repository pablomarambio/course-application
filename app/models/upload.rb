require 'csv'
class Upload < ActiveRecord::Base

  enum upload_type: [:users, :courses, :results]

  validates :upload_type, presence: true
  validates :file, presence: true

  after_create :read_rows

  attr_accessor :rows
  has_many :upload_results

  def read_rows
    self.rows = []
    CSV.parse(file, {headers: true, col_sep: ';' }) do |row|
      self.rows << row
    end
  end

  def process_all_rows
    self.rows.each_with_index do |row, index|
      process_row(index)
    end
  end

  def process_row(index)

    row = self.rows[index-1]

    case upload_type

    when "users"
      unless row["ID"].nil?
        @user = User.where(id:row["ID"]).first
        #check if update
        if @user && (row["Email"] || row["Name"] || row["Password"] || row["RUT"] || row["Course_Batch"])
          @user.email = row["Email"] if row["Email"]
          @user.name = row["Name"] if row["Name"]
          @user.password = row["Password"] if row["Password"]
          @user.rut =  row["RUT"] if row["RUT"]
          @user.course_batch_id = row["Course_Batch"] if row["Course_Batch"]
          if @user.save
            # results_for_row[index] = "User updated"
            upload_results << UploadResult.create(message:"User updated", row_number: index, result_type: "Success")
          else
            upload_results << UploadResult.create(message:@user.errors.full_messages.to_sentence, row_number: index-1, result_type: "Error")
          end
        else
          #we are deleting this one
          if @user && @user.destroy
            upload_results << UploadResult.create(message:"User deleted", row_number: index, result_type: "Success")
          else
            upload_results << UploadResult.create(message:"User not found", row_number: index, result_type: "Error")
          end
        end
      else
        #id was nil, so create
        @user = User.new(email: row["Email"], name: row["Name"], password:row["Password"], rut: row["RUT"], course_batch_id: row["Course_Batch"])
        if @user.save
          upload_results << UploadResult.create(message:"User created", row_number: index, result_type: "Success")
        else
          upload_results << UploadResult.create(message:@user.errors.full_messages.to_sentence, row_number: index, result_type: "Error")
        end
      end #unless

    when "courses"
      unless row["ID"].nil?
        @course = Course.where(id:row["ID"]).first
        #check if update
        if @course && (row["Name"] or row["Classroom"] or row["Capacity"] or row["Batch"] or row["Block"])
            #update or create block
            @block = Block.find_or_initialize_by(name: row["Block"],from: row["From"], to: row["To"])
            @block.courses << @course
            #update or create batch
            @course_batch = CourseBatch.find_or_initialize_by(name: row["Batch"])
            @course_batch.blocks << @block
            @course.course_batch = @course_batch
            if @course_batch.valid?
              if @block.valid?
                #update course
                @course.name = row["Name"] if row["Name"]
                @course.name = row["Classroom"] if row["Classroom"]
                @course.name = row["Capacity"] if row["Capacity"]
                if @course.save
                  upload_results << UploadResult.create(message:"Course updated", row_number: index, result_type: "Success")
                else
                  upload_results << UploadResult.create(message:@course.errors.full_messages.to_sentence, row_number: index-1, result_type: "Error")
                end
              else
                upload_results << UploadResult.create(message:@block.errors.full_messages.to_sentence, row_number: index, result_type: "Error")
              end
            else
              upload_results << UploadResult.create(message:@course_batch.errors.full_messages.to_sentence, row_number: index, result_type: "Error")
            end


        else
          #we are deleting this one
          if @course && @course.destroy
            upload_results << UploadResult.create(message:"Course deleted", row_number: index, result_type: "Success")
          else
            upload_results << UploadResult.create(message:"Course not found", row_number: index, result_type: "Error")
          end
        end
      else
        #id was nil, so create
        #create course
        @course = Course.new(name: row["Name"], classroom:row["Classroom"], capacity: row["Capacity"])
        if @course.save
        ## find or create block
          @block = Block.find_or_initialize_by(name: row["Block"],from: row["From"], to: row["To"])
          @block.courses << @course
          if @block.save
            # # find or create batch
            @course_batch = CourseBatch.find_or_initialize_by(name: row["Batch"])
            @course_batch.blocks << @block
            if @course_batch.save
              @course.course_batch = @course_batch
              @course.save
              upload_results << UploadResult.create(message:"Course created", row_number: index, result_type: "Success")
            else
              upload_results << UploadResult.create(message:@course_batch.errors.full_messages.to_sentence, row_number: index, result_type: "Error")
            end
          else
            upload_results << UploadResult.create(message:@block.errors.full_messages.to_sentence, row_number: index, result_type: "Error")
          end
        else
          upload_results << UploadResult.create(message:@course.errors.full_messages.to_sentence, row_number: index, result_type: "Error")
        end
      end#unless

    when "results"
      unless row["RUT"].nil?
        @user = User.where(rut:row["RUT"]).first
        unless @user.blank?
          if (row["Block"] && row["Course"])
            #update or create
            @block =  Block.where(name: row["Block"]).first
            if @block
                #check if result exists
                @result = Result.find_or_initialize_by(user_id: @user.id, block_id: @block.id)
                unless @result.id.nil?
                  #we are updating
                  @course =  Course.where(name: row["Course"]).first
                  if @course
                    @result.course = @course
                    if @result.save
                      upload_results << UploadResult.create(message:"Result updated", row_number: index, result_type: "Success")
                    else
                      upload_results << UploadResult.create(message:@result.errors.full_messages.to_sentence, row_number: index, result_type: "Error")
                    end
                  else
                    #missing course
                    upload_results << UploadResult.create(message:"Course not found", row_number: index, result_type: "Error")
                  end
                else
                  #we are creating
                  @course =  Course.where(name: row["Course"]).first
                  if @course
                    @result.course = @course
                    if @result.save
                      upload_results << UploadResult.create(message:"Result created", row_number: index, result_type: "Success")
                    else
                      upload_results << UploadResult.create(message:@result.errors.full_messages.to_sentence, row_number: index, result_type: "Error")
                    end
                  else
                    #missing course
                    upload_results << UploadResult.create(message:"Course not found", row_number: index, result_type: "Error")
                  end
                end
            else
              #missing block
              upload_results << UploadResult.create(message:"Block not found", row_number: index, result_type: "Error")
            end
          else
            #delete
            if @user.applications.destroy_all
              upload_results << UploadResult.create(message:"All applications for user have been deleted", row_number: index, result_type: "Success")
            end
          end
        else
          upload_results << UploadResult.create(message:"Student not found", row_number: index, result_type: "Error")
        end

      else

      end
    end #when
  end #def

end #class