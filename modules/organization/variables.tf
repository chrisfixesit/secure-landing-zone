variable "approved_regions" {
  description = "Regions where activity is permitted organization-wide"
  type        = list(string)
  default     = ["us-east-1"]

  validation {
    condition     = length(var.approved_regions) > 0
    error_message = "At least one approved region is required."
  }
}
