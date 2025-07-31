#!/bin/bash

# Version Management Script for MCP-XGeneOps
VERSION_FILE="version.txt"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔢 MCP-XGeneOps Version Management${NC}"
echo ""

# Function to get current version
get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "v0"
    fi
}

# Function to increment version
increment_version() {
    local current_version=$(get_current_version)
    local version_num=$(echo $current_version | sed 's/v//')
    local new_version_num=$((version_num + 1))
    echo "v$new_version_num"
}

# Function to set specific version
set_version() {
    local new_version=$1
    echo "$new_version" > "$VERSION_FILE"
    echo -e "${GREEN}✅ Version set to: $new_version${NC}"
}

# Function to show current version
show_version() {
    local current_version=$(get_current_version)
    echo -e "${YELLOW}📋 Current version: $current_version${NC}"
}

# Function to increment version
increment_version_cmd() {
    local current_version=$(get_current_version)
    local new_version=$(increment_version)
    set_version "$new_version"
    echo -e "${GREEN}🔄 Version incremented from $current_version to $new_version${NC}"
}

# Function to show all versions in Harbor
show_harbor_versions() {
    echo -e "${YELLOW}📦 Versions in Harbor:${NC}"
    echo "Frontend versions:"
    curl -s http://172.16.20.11:8443/v2/mcpxgenops/frontend/tags/list 2>/dev/null | grep -o 'v[0-9]*' | sort -V | tail -5
    echo ""
    echo "Backend versions:"
    curl -s http://172.16.20.11:8443/v2/mcpxgenops/backend/tags/list 2>/dev/null | grep -o 'v[0-9]*' | sort -V | tail -5
    echo ""
    echo "AI Service versions:"
    curl -s http://172.16.20.11:8443/mcpxgenops/ai-service/tags/list 2>/dev/null | grep -o 'v[0-9]*' | sort -V | tail -5
}

# Function to show help
show_help() {
    echo -e "${BLUE}Usage:${NC}"
    echo "  $0 [command]"
    echo ""
    echo -e "${BLUE}Commands:${NC}"
    echo "  show              - Show current version"
    echo "  increment         - Increment version (v1 -> v2)"
    echo "  set <version>     - Set specific version (e.g., set v5)"
    echo "  harbor            - Show versions in Harbor registry"
    echo "  help              - Show this help message"
    echo ""
    echo -e "${BLUE}Examples:${NC}"
    echo "  $0 show"
    echo "  $0 increment"
    echo "  $0 set v10"
    echo "  $0 harbor"
}

# Main script logic
case "${1:-help}" in
    "show")
        show_version
        ;;
    "increment")
        increment_version_cmd
        ;;
    "set")
        if [ -z "$2" ]; then
            echo -e "${RED}❌ Error: Please provide a version number${NC}"
            echo "Usage: $0 set <version>"
            exit 1
        fi
        set_version "$2"
        ;;
    "harbor")
        show_harbor_versions
        ;;
    "help"|*)
        show_help
        ;;
esac 