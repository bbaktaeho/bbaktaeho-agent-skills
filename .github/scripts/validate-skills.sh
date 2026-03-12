#!/usr/bin/env bash
set -euo pipefail

ERRORS=0
PASSES=0

pass() {
  echo "[PASS] $1"
  PASSES=$((PASSES + 1))
}

fail() {
  echo "[FAIL] $1"
  ERRORS=$((ERRORS + 1))
}

# Extract YAML frontmatter value from a file
# Usage: get_frontmatter_field <file> <field>
get_frontmatter_field() {
  local file="$1"
  local field="$2"
  sed -n '/^---$/,/^---$/p' "$file" | grep "^${field}:" | head -1 | sed "s/^${field}:[[:space:]]*//"
}

# Extract multiline description (handles > folded style)
get_description() {
  local file="$1"
  local in_desc=false
  local desc=""
  while IFS= read -r line; do
    if [[ "$line" == "---" && -n "$desc" ]]; then
      break
    fi
    if $in_desc; then
      if [[ "$line" =~ ^[a-zA-Z_]+: || "$line" == "---" ]]; then
        break
      fi
      desc="$desc $(echo "$line" | sed 's/^[[:space:]]*//')"
    fi
    if [[ "$line" =~ ^description: ]]; then
      local inline
      inline=$(echo "$line" | sed 's/^description:[[:space:]]*//')
      if [[ "$inline" != ">" && "$inline" != "|" && -n "$inline" ]]; then
        echo "$inline"
        return
      fi
      in_desc=true
    fi
  done < "$file"
  echo "$desc" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//'
}

# Count body lines (lines after second ---)
count_body_lines() {
  local file="$1"
  local count=0
  local dashes=0
  while IFS= read -r line; do
    if [[ "$line" == "---" ]]; then
      dashes=$((dashes + 1))
      continue
    fi
    if [[ $dashes -ge 2 ]]; then
      count=$((count + 1))
    fi
  done < "$file"
  echo "$count"
}

# Check for XML tags in a string
has_xml_tags() {
  echo "$1" | grep -qE '<[a-zA-Z][^>]*>'
}

echo "=== Skill Format Validation ==="
echo ""

# ----------------------------------------
# 1. Validate marketplace.json
# ----------------------------------------
echo "--- marketplace.json ---"
MARKETPLACE=".claude-plugin/marketplace.json"

if [[ ! -f "$MARKETPLACE" ]]; then
  fail "marketplace.json: file not found"
else
  pass "marketplace.json: file exists"

  # Check required top-level fields
  for field in name description owner plugins; do
    if jq -e ".$field" "$MARKETPLACE" > /dev/null 2>&1; then
      pass "marketplace.json: top-level field '$field' present"
    else
      fail "marketplace.json: missing top-level field '$field'"
    fi
  done

  # Check each plugin entry
  plugin_count=$(jq '.plugins | length' "$MARKETPLACE")
  for i in $(seq 0 $((plugin_count - 1))); do
    pname=$(jq -r ".plugins[$i].name" "$MARKETPLACE")

    for field in name description source category; do
      val=$(jq -r ".plugins[$i].$field // empty" "$MARKETPLACE")
      if [[ -n "$val" ]]; then
        pass "marketplace.json: plugin '$pname' has '$field'"
      else
        fail "marketplace.json: plugin '$pname' missing '$field'"
      fi
    done

    # Check source path exists
    source_path=$(jq -r ".plugins[$i].source" "$MARKETPLACE")
    # Remove leading ./
    source_path="${source_path#./}"
    if [[ -d "$source_path" ]]; then
      pass "marketplace.json: plugin '$pname' source path exists ($source_path)"
    else
      fail "marketplace.json: plugin '$pname' source path not found ($source_path)"
    fi
  done
fi

echo ""

# ----------------------------------------
# 2. Validate each plugin
# ----------------------------------------
for plugin_dir in plugins/*/; do
  plugin_name=$(basename "$plugin_dir")
  echo "--- plugins/$plugin_name ---"

  # Check plugin.json exists
  plugin_json="$plugin_dir.claude-plugin/plugin.json"
  if [[ ! -f "$plugin_json" ]]; then
    fail "plugins/$plugin_name: .claude-plugin/plugin.json not found"
  else
    pass "plugins/$plugin_name: plugin.json exists"

    # Check required fields
    for field in name description version; do
      val=$(jq -r ".$field // empty" "$plugin_json")
      if [[ -n "$val" ]]; then
        pass "plugins/$plugin_name: plugin.json '$field' present"
      else
        fail "plugins/$plugin_name: plugin.json missing '$field'"
      fi
    done

    # Check author.name
    author_name=$(jq -r ".author.name // empty" "$plugin_json")
    if [[ -n "$author_name" ]]; then
      pass "plugins/$plugin_name: plugin.json 'author.name' present"
    else
      fail "plugins/$plugin_name: plugin.json missing 'author.name'"
    fi
  fi

  # Find all SKILL.md files
  skill_found=false
  while IFS= read -r skill_md; do
    skill_found=true
    skill_dir=$(dirname "$skill_md")
    skill_dir_name=$(basename "$skill_dir")
    rel_path="${skill_md#plugins/}"

    pass "plugins/$plugin_name: SKILL.md found ($rel_path)"

    # --- name validation ---
    name_val=$(get_frontmatter_field "$skill_md" "name")
    if [[ -z "$name_val" ]]; then
      fail "plugins/$plugin_name: SKILL.md 'name' field missing"
    else
      pass "plugins/$plugin_name: SKILL.md 'name' present ($name_val)"

      # Max 64 chars
      if [[ ${#name_val} -le 64 ]]; then
        pass "plugins/$plugin_name: name length OK (${#name_val}/64)"
      else
        fail "plugins/$plugin_name: name exceeds 64 chars (${#name_val})"
      fi

      # Lowercase + numbers + hyphens only
      if [[ "$name_val" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]]; then
        pass "plugins/$plugin_name: name format valid"
      else
        fail "plugins/$plugin_name: name '$name_val' must be lowercase letters, numbers, hyphens only (no leading/trailing hyphens)"
      fi

      # No double hyphens
      if [[ "$name_val" == *--* ]]; then
        fail "plugins/$plugin_name: name '$name_val' contains consecutive hyphens"
      else
        pass "plugins/$plugin_name: name no consecutive hyphens"
      fi

      # No reserved words
      name_lower=$(echo "$name_val" | tr '[:upper:]' '[:lower:]')
      if [[ "$name_lower" == *anthropic* || "$name_lower" == *claude* ]]; then
        fail "plugins/$plugin_name: name '$name_val' contains reserved word (anthropic/claude)"
      else
        pass "plugins/$plugin_name: name no reserved words"
      fi

      # No XML tags
      if has_xml_tags "$name_val"; then
        fail "plugins/$plugin_name: name contains XML tags"
      else
        pass "plugins/$plugin_name: name no XML tags"
      fi

      # Name matches directory name
      if [[ "$name_val" == "$skill_dir_name" ]]; then
        pass "plugins/$plugin_name: name matches directory name"
      else
        fail "plugins/$plugin_name: name '$name_val' does not match directory name '$skill_dir_name'"
      fi
    fi

    # --- description validation ---
    desc_val=$(get_description "$skill_md")
    if [[ -z "$desc_val" ]]; then
      fail "plugins/$plugin_name: SKILL.md 'description' field missing or empty"
    else
      pass "plugins/$plugin_name: SKILL.md 'description' present"

      # Max 1024 chars
      if [[ ${#desc_val} -le 1024 ]]; then
        pass "plugins/$plugin_name: description length OK (${#desc_val}/1024)"
      else
        fail "plugins/$plugin_name: description exceeds 1024 chars (${#desc_val})"
      fi

      # No XML tags
      if has_xml_tags "$desc_val"; then
        fail "plugins/$plugin_name: description contains XML tags"
      else
        pass "plugins/$plugin_name: description no XML tags"
      fi
    fi

    # --- body line count ---
    body_lines=$(count_body_lines "$skill_md")
    if [[ $body_lines -le 100 ]]; then
      pass "plugins/$plugin_name: SKILL.md body $body_lines lines (max 100)"
    else
      fail "plugins/$plugin_name: SKILL.md body $body_lines lines exceeds 100"
    fi

  done < <(find "$plugin_dir" -name "SKILL.md" -type f)

  if ! $skill_found; then
    fail "plugins/$plugin_name: no SKILL.md found"
  fi

  echo ""
done

# ----------------------------------------
# Summary
# ----------------------------------------
echo "=== Summary ==="
echo "Passed: $PASSES"
echo "Failed: $ERRORS"

if [[ $ERRORS -gt 0 ]]; then
  echo ""
  echo "Validation failed with $ERRORS error(s)."
  exit 1
else
  echo ""
  echo "All checks passed."
  exit 0
fi
