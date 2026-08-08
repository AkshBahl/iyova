#!/usr/bin/env bash
# Creates all IYOVA showcase pages and journal blog in Shopify.
# Run from theme folder after: shopify auth login
# Usage: ./scripts/setup-store-pages.sh

set -euo pipefail

STORE="${SHOPIFY_STORE:-es18iq-hw.myshopify.com}"

create_page() {
  local title="$1"
  local handle="$2"
  local suffix="$3"
  echo "Creating page: $title ($handle)..."
  shopify store execute --store "$STORE" --allow-mutations --query "
    mutation {
      pageCreate(page: {
        title: \"$title\",
        handle: \"$handle\",
        body: \"<p></p>\",
        templateSuffix: \"$suffix\"
      }) {
        page { handle id }
        userErrors { message }
      }
    }
  " 2>&1 || true
  echo ""
}

echo "Setting up IYOVA pages on $STORE"
echo "================================"

create_page "About Us" "about-us" "about"
create_page "Contact Us" "contact-us" "contact"
create_page "Warranty Registration" "warranty-registration" "warranty"
create_page "Shipping" "shipping" "shipping"
create_page "Returns" "returns" "returns"
create_page "FAQs" "faqs" "faqs"
create_page "Track Order" "track-order" "track-order"
create_page "Privacy Policy" "privacy-policy" "privacy"
create_page "Terms & Conditions" "terms-and-conditions" "terms"
create_page "Wishlist" "wishlist" "wishlist"

echo "Creating Journal blog..."
shopify store execute --store "$STORE" --allow-mutations --query '
  mutation {
    blogCreate(blog: { title: "Journal", handle: "journal" }) {
      blog { handle id }
      userErrors { message }
    }
  }
' 2>&1 || true

echo ""
echo "If you saw auth errors, run first:"
echo "  shopify store auth --store $STORE --scopes read_content,write_content"
echo "Then re-run: ./scripts/setup-store-pages.sh"
echo ""
echo "Done! Refresh your storefront and test header/footer links."
