module FlashHelper
  FLASH_TYPES = {
    "notice" => "success",
    "alert" => "danger"
  }.freeze

  def flash_class(type)
    FLASH_TYPES.fetch(type, "info")
  end
end
