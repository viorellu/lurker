# lurker
resigilate.sh - a quick and dirty way for watching the resealed RTX video boards product page on the Romanian EMAG online store. It pools the page every 5 minutes.

Changes so far:
- initial - a simple curl with text processing to obtain a line of text containing the product name and price
- split results in good or bad price by comparing the value obtained with curl against a set value
- added beep notification and flashy window when good price is found
- addded logging with timestamp for good price results. The result line is hashed with md5sum and the hash is added in the log as well.
Comparing the hash for each newly found good price result against the log prevents getting more than 1 notification for a certain product.
- added push notifications using Pushover
- improved price field separation
- prices are now sorted low to high on terminal output
