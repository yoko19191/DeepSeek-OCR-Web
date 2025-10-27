import { Textarea } from './ui/textarea';
import { Button } from './ui/button';
import { Sparkles, Loader2 } from 'lucide-react';
import { ScrollArea } from './ui/scroll-area';

interface PromptInputProps {
  prompt: string;
  onPromptChange: (value: string) => void;
  onParse: () => void;
  isProcessing: boolean;
  hasFile: boolean;
  isCompact?: boolean;
}

export function PromptInput({
  prompt,
  onPromptChange,
  onParse,
  isProcessing,
  hasFile,
  isCompact = false,
}: PromptInputProps) {
  return (
    <div className="h-full flex flex-col min-h-0">
      <div className="bg-white/50 backdrop-blur-sm rounded-xl border border-gray-200 shadow-lg p-4 mb-3 flex-1 flex flex-col min-h-0">
        <label className="block text-sm text-gray-600 mb-2 flex-shrink-0">提示词输入</label>
        <div className="flex-1 min-h-0">
          <ScrollArea className="h-full w-full">
            <Textarea
              value={prompt}
              onChange={(e) => onPromptChange(e.target.value)}
              className={`w-full bg-white/80 border-gray-200 focus:border-teal-400 focus:ring-teal-400 resize-none ${
                isCompact ? 'min-h-[40px]' : 'min-h-[100px]'
              }`}
              placeholder="输入您的提示词..."
            />
          </ScrollArea>
        </div>
      </div>

      {!isCompact && (
        <div className="h-11 flex-shrink-0">
          <Button
            onClick={onParse}
            disabled={!hasFile || isProcessing}
            className="w-full h-full bg-gradient-to-r from-teal-500 to-cyan-500 hover:from-teal-600 hover:to-cyan-600 text-white shadow-lg disabled:opacity-50 disabled:from-gray-300 disabled:to-gray-400 transition-all hover:shadow-xl hover:scale-[1.02] cursor-pointer disabled:cursor-not-allowed"
          >
            {isProcessing ? (
              <>
                <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                解析中...
              </>
            ) : (
              <>
                <Sparkles className="mr-2 h-5 w-5" />
                开始解析
              </>
            )}
          </Button>
        </div>
      )}
    </div>
  );
}