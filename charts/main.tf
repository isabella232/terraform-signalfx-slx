resource "signalfx_time_chart" "slx_success_ratio_chart" {
  name = "Success Ratio"

  program_text = <<-EOF
        A = ${var.successful_operations_sli_count_query}.publish('Successful Operations', enable=False)
        B = ${var.total_operations_sli_count_query}.publish('Total Operations', enable=False)
        C = ((A/B)*100).publish(label='Success Ratio')
        EOF

  time_range = "-15m"

  plot_type         = "LineChart"
  show_data_markers = true

  axis_left {
    low_watermark = "${var.operation_success_ratio_slo_target}"
    low_watermark_label = "Target SLO"
  }
}

resource "signalfx_time_chart" "slx_operation_duration_chart" {
  name = "Operation Duration"

  program_text = <<-EOF
        A = ${var.operation_time_sli_query}.publish('Operation Duration')
        EOF

  time_range = "-15m"

  plot_type         = "LineChart"
  show_data_markers = true

  axis_left {
    low_watermark = "${var.operation_time_slo_target}"
    low_watermark_label = "Target SLO"
  }

  viz_options {
    label = "Operation Duration"
    value_unit = "${var.operation_time_sli_unit}"
  }
}

resource "signalfx_time_chart" "slx_total_errors_chart" {
  name = "Rate of Errors"

  program_text = <<-EOF
        A = ${var.error_operations_sli_count_query}.publish('Errors')
        EOF

  time_range = "-15m"

  plot_type         = "LineChart"
  show_data_markers = true

  viz_options {
    label = "Errors"
    color = "orange"
  }
}

resource "signalfx_single_value_chart" "slx_success_ratio_instant_chart" {
    name = "Success Ratio"

    program_text = <<-EOF
        A = ${var.successful_operations_sli_count_query}.publish('Successful Operations', enable=False)
        B = ${var.total_operations_sli_count_query}.publish('Total Operations', enable=False)
        C = ((A/B)*100).publish(label='Success Ratio')
        EOF

    description = "Current Value Against SLO (${var.operation_success_ratio_slo_target})"

    refresh_interval = 1
    max_precision = 2
    is_timestamp_hidden = true
    color_by = "Scale"
    color_scale = [
      {
        lt = "${var.operation_success_ratio_slo_target}",
        color =  "orange"
      },
      {
        gte = "${var.operation_success_ratio_slo_target}",
        color = "green"
      }
    ]
}

resource "signalfx_single_value_chart" "slx_operation_duration_instant_chart" {
    name = "Operation Duration"

    program_text = <<-EOF
        A = ${var.operation_time_sli_query}.publish('Operation Duration')
        EOF

    description = "Current Value Against SLO (${var.operation_time_slo_target})"

    viz_options {
      label = "Operation Duration"
      value_unit = "${var.operation_time_sli_unit}"
    }

    refresh_interval = 1
    max_precision = 2
    is_timestamp_hidden = true
    color_by = "Scale"
    color_scale = [
      {
        gt = "${var.operation_time_slo_target}",
        color =  "orange"
      },
      {
        lte = "${var.operation_time_slo_target}",
        color = "green"
      }
    ]
}

resource "signalfx_single_value_chart" "slx_total_errors_instant_chart" {
    name = "Error Rate"

    program_text = <<-EOF
        A = ${var.error_operations_sli_count_query}.publish('Errors')
        EOF

    description = "Current Error Rate"

    refresh_interval = 1
    max_precision = 2
    is_timestamp_hidden = true

    color_by = "Scale"
    color_scale = [
      {
        gt = "0",
        color =  "orange"
      },
      {
        lte = "0",
        color =  "gray"
      }
    ]
}

resource "signalfx_time_chart" "slx_total_rate_chart" {
  name = "Rate of Operations"

  program_text = <<-EOF
        A = ${var.total_operations_sli_count_query}.publish('Operations')
        EOF

  time_range = "-15m"

  plot_type         = "LineChart"
  show_data_markers = true
}