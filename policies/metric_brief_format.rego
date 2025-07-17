package before_resolution
import rego.v1

# This file enforces formatting policies for metric briefs.
# Metric briefs should end with a period (.).

# Helper to create metric brief formatting violations.
metric_brief_violation(description, group_id) = violation if {
    violation := {
        "id": description,
        "type": "semconv_attribute",
        "category": "metric_brief_formatting",
        "group": group_id,
        "attr": "",
    }
}

# Check that metric briefs end with a period
deny contains metric_brief_violation(description, group.id) if {
    group := input.groups[_]
    group.type == "metric"
    brief := group.brief
    brief != null
    
    # Remove leading/trailing whitespace and check if it ends with period
    trimmed_brief := trim(brief, " \t\n\r")
    not endswith(trimmed_brief, ".")
    
    description := sprintf("Metric brief '%s' should end with a period (.). Metric briefs must end with a period.", [trimmed_brief])
}