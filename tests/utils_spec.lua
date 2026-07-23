local li = require('likelihud')

describe('utils', function()
    local utils = li.utils

    describe('textAtWidth', function()
        describe('one character == 1 unit length', function()
            local f = {
                getWidth = function (_, text)
                    return text:len()
                end
            }

            it('empty text', function()
                assert.is.equal(utils.textAtWidth('', 0 , f), '')
                assert.is.equal(utils.textAtWidth('', 1 , f), '')
                assert.is.equal(utils.textAtWidth('', 2 , f), '')
                assert.is.equal(utils.textAtWidth('', 10, f), '')
            end)

            it('1-character text', function()
                assert.is.equal(utils.textAtWidth('a', 0 , f), '')
                assert.is.equal(utils.textAtWidth('a', 1 , f), 'a')
                assert.is.equal(utils.textAtWidth('a', 2 , f), 'a')
                assert.is.equal(utils.textAtWidth('a', 10, f), 'a')
            end)

            it('simple cases', function()
                assert.is.equal(utils.textAtWidth('abcd', 0 , f), '')
                assert.is.equal(utils.textAtWidth('abcd', 1 , f), 'a')
                assert.is.equal(utils.textAtWidth('abcd', 2 , f), 'ab')
                assert.is.equal(utils.textAtWidth('abcd', 3 , f), 'abc')
                assert.is.equal(utils.textAtWidth('abcd', 10, f), 'abcd')
            end)

            it('general', function()
                local text = 'abcdefghijklmnop'
                for i = 0, text:len() do
                    assert.is.equal(utils.textAtWidth(text, i, f), text:sub(1, i))
                end
            end)
        end)

        describe('one character == 1.5 unit length', function()
            local f = {
                getWidth = function (_, text)
                    return text:len() * 1.5
                end
            }

            it('empty text', function()
                assert.is.equal(utils.textAtWidth('', 0 , f), '')
                assert.is.equal(utils.textAtWidth('', 1 , f), '')
                assert.is.equal(utils.textAtWidth('', 2 , f), '')
                assert.is.equal(utils.textAtWidth('', 10, f), '')
            end)

            it('1-character text', function()
                assert.is.equal(utils.textAtWidth('a', 0 , f), '')
                assert.is.equal(utils.textAtWidth('a', 1 , f), '')
                assert.is.equal(utils.textAtWidth('a', 2 , f), 'a')
                assert.is.equal(utils.textAtWidth('a', 10, f), 'a')
            end)

            it('general', function()
                assert.is.equal(utils.textAtWidth('abcd', 0, f), '')
                assert.is.equal(utils.textAtWidth('abcd', 1, f), '')
                assert.is.equal(utils.textAtWidth('abcd', 2, f), 'a')
                assert.is.equal(utils.textAtWidth('abcd', 3, f), 'ab')
                assert.is.equal(utils.textAtWidth('abcd', 4, f), 'ab')
                assert.is.equal(utils.textAtWidth('abcd', 5, f), 'abc')
                assert.is.equal(utils.textAtWidth('abcd', 6, f), 'abcd')
            end)
        end)

        describe('one character == 0.7 unit length', function()
            local f = {
                getWidth = function (_, text)
                    return text:len() * 0.7
                end
            }

            it('empty text', function()
                assert.is.equal(utils.textAtWidth('', 0, f), '')
                assert.is.equal(utils.textAtWidth('', 1, f), '')
                assert.is.equal(utils.textAtWidth('', 2, f), '')
                assert.is.equal(utils.textAtWidth('', 10, f), '')
            end)

            it('1-character text', function()
                assert.is.equal(utils.textAtWidth('a', 0, f), '')
                assert.is.equal(utils.textAtWidth('a', 1, f), 'a')
                assert.is.equal(utils.textAtWidth('a', 2, f), 'a')
                assert.is.equal(utils.textAtWidth('a', 10, f), 'a')
            end)

            it('general', function()
                assert.is.equal(utils.textAtWidth('abcdefg', 0, f), '')
                assert.is.equal(utils.textAtWidth('abcdefg', 1, f), 'a')
                assert.is.equal(utils.textAtWidth('abcdefg', 2, f), 'ab')
                assert.is.equal(utils.textAtWidth('abcdefg', 3, f), 'abcd')
                assert.is.equal(utils.textAtWidth('abcdefg', 4, f), 'abcde')
                assert.is.equal(utils.textAtWidth('abcdefg', 5, f), 'abcdefg')
                assert.is.equal(utils.textAtWidth('abcdefg', 6, f), 'abcdefg')
            end)
        end)
    end) -- textAtWidth

    describe('usub', function()
        local compare = function (text, from, to)
            return utils.usub(text, from, to) == text:sub(from, to)
        end

        it('text = \'\'', function()
            local text = ''

            assert.is_true(compare(text, 0))
            assert.is_true(compare(text, 1))
            assert.is_true(compare(text, 2))
            assert.is_true(compare(text, -1))
            assert.is_true(compare(text, -2))

            assert.is_true(compare(text, 0, 1))
            assert.is_true(compare(text, 1, 2))
            assert.is_true(compare(text, 2, 3))
            assert.is_true(compare(text, -1, -2))
            assert.is_true(compare(text, -2, -1))
        end)

        it('text = abcdef', function()
            local text = 'abcdef'

            assert.is_true(compare(text, 0))
            assert.is_true(compare(text, 1))
            assert.is_true(compare(text, 2))
            assert.is_true(compare(text, 3))
            assert.is_true(compare(text, 4))
            assert.is_true(compare(text, 5))
            assert.is_true(compare(text, 6))
            assert.is_true(compare(text, 7))
            assert.is_true(compare(text, 8))
            assert.is_true(compare(text, -1))
            assert.is_true(compare(text, -2))
            assert.is_true(compare(text, -3))
            assert.is_true(compare(text, -4))
            assert.is_true(compare(text, -5))
            assert.is_true(compare(text, -6))
            assert.is_true(compare(text, -7))
            assert.is_true(compare(text, -8))

            assert.is_true(compare(text, 0, 1))
            assert.is_true(compare(text, 1, 2))
            assert.is_true(compare(text, 2, 3))
            assert.is_true(compare(text, 1, 3))
            assert.is_true(compare(text, 1, 5))
            assert.is_true(compare(text, 1, 7))
            assert.is_true(compare(text, -3, -1))
            assert.is_true(compare(text, -4, -2))
            assert.is_true(compare(text, -3, -7))
        end)

        it('text = привет', function()
            local text = 'привет'

            assert.is.equal(utils.usub(text, 1, 1), 'п')
            assert.is.equal(utils.usub(text, 1, 2), 'пр')
            assert.is.equal(utils.usub(text, 1, 3), 'при')
            assert.is.equal(utils.usub(text, 1, 4), 'прив')
            assert.is.equal(utils.usub(text, 1, 5), 'приве')
            assert.is.equal(utils.usub(text, 1, 6), 'привет')
            assert.is.equal(utils.usub(text, 1, 7), 'привет')

            assert.is.equal(utils.usub(text, 0, 1), 'п')
            assert.is.equal(utils.usub(text, 0, 2), 'пр')
            assert.is.equal(utils.usub(text, 0, 3), 'при')
            assert.is.equal(utils.usub(text, 0, 4), 'прив')
            assert.is.equal(utils.usub(text, 0, 5), 'приве')
            assert.is.equal(utils.usub(text, 0, 6), 'привет')
            assert.is.equal(utils.usub(text, 0, 7), 'привет')

            assert.is.equal(utils.usub(text, -1), 'т')
            assert.is.equal(utils.usub(text, -2), 'ет')
            assert.is.equal(utils.usub(text, -3), 'вет')
            assert.is.equal(utils.usub(text, -4), 'ивет')
            assert.is.equal(utils.usub(text, -5), 'ривет')
            assert.is.equal(utils.usub(text, -6), 'привет')
            assert.is.equal(utils.usub(text, -7), 'привет')

            assert.is.equal(utils.usub(text, 1, 2), 'пр')
            assert.is.equal(utils.usub(text, 3, 4), 'ив')
            assert.is.equal(utils.usub(text, 5, 6), 'ет')

            assert.is.equal(utils.usub(text, 3, 7), 'ивет')
            assert.is.equal(utils.usub(text, 2, 4), 'рив')

            assert.is.equal(utils.usub(text, 6, 3), '')
        end)
    end) -- usub
end)

