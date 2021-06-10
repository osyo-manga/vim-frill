import re
import os

from denite.base.source import Base
from denite.util import relpath, Nvim, UserContext, Candidates

class Source(Base):
	def __init__(self, vim):
		super().__init__(vim)
		self.name = 'frill'
		self.kind = 'file'
		self.max_candidates = 50
		self.sorters = []

	def gather_candidates(self, context):
		candidates = self.vim.call('frill#get', 'file')
		
		return list(map(lambda candidate: {
			'word': candidate,
			'action__path': os.path.expandvars(candidate)
			}, candidates))
