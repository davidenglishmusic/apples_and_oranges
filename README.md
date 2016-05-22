# Apples and Oranges

Testing automation can be tricky. Sometimes, the only way to catch something is through visual inspection. The Apples and Oranges gem automates the creation of baseline screenshots and then subsequently runs a comparison with them when the tests are next run.

To use Apples and Oranges, install the gem, and then include a few snippets in your capybara/rspec code.

```
describe 'Example' do
  before (:all) do
    @grocer = ApplesAndOranges.new
  end

  it "compares a screenshot of the gem's github page" do
    visit(https://github.com/davidenglishmusic/apples_and_oranges)
    expect(@grocer.check_screenshot(page)).to eq true
  end
end
```

On the first pass, a screenshot will be created and false will be returned. On a subsequent run the comparison will run and will return true if the test screenshot matches the baseline one.

So far I have just used it with https://github.com/teampoltergeist/poltergeist - it may work with other drivers but perhaps not.

The baseline screenshot file management is dependent on the line number of the command. Adding additional lines before the ```expect(@grocer.check_screenshot(page)).to eq true``` command will result in a new screenshot being created.

To clear the previous baseline screenshots, remove the directories/files housed in ```/spec/fixtures/ao_screenshots```.
